class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy, :update_status, :revert]

  def index
    @selected_date = params[:date]&.to_date || Time.zone.today
    @collections = Collection.includes(:market).by_date(@selected_date)
    
    # 상태 필터 적용
    @collections = @collections.where(status: params[:status]) if params[:status].present?
    
    @collections = @collections.order(:scheduled_at)
    @markets = Market.all
    @summary = calculate_summary(Collection.includes(:market).by_date(@selected_date))
  end

  def history
    @selected_date = params[:date]&.to_date
    
    if @selected_date.present?
      # 선택된 날짜의 시작과 끝 시간 계산
      start_time = @selected_date.beginning_of_day
      end_time = @selected_date.end_of_day
      
      @past_collections = Collection.includes(:market).where(scheduled_at: start_time..end_time)
      
      # 필터 적용
      @past_collections = @past_collections.where(market_id: params[:market_id]) if params[:market_id].present?
      @past_collections = @past_collections.where(status: params[:status]) if params[:status].present?
      @past_collections = @past_collections.where("receiver ILIKE ?", "%#{params[:receiver]}%") if params[:receiver].present?
      
      @past_collections = @past_collections.order(scheduled_at: :desc)
    else
      @past_collections = Collection.none
    end
    
    @markets = Market.all
    @summary = calculate_summary(@past_collections)
  end

  def invoice
    @date = Date.parse(params[:date])
    @collections_by_market = Collection.includes(:market)
                                      .where(scheduled_at: @date.beginning_of_day..@date.end_of_day)
                                      .where(status: :completed)
                                      .group_by(&:market)

    respond_to do |format|
      format.html # for 웹 확인용
      format.pdf do
        render pdf: "invoice_#{@date}",
               template: "collections/invoice",
               layout: false,
               page_size: 'A4',
               encoding: 'UTF-8',
               print_media_type: true,
               margin: { top: 10, bottom: 10, left: 10, right: 10 }
      end
    end
  end

  def new
    @collection = Collection.new
    @markets = Market.all
  end

  def create
    @collection = Collection.new(collection_params)
    @collection.status = :in_progress
    
    if @collection.save
      redirect_to collections_path, notice: '수거 접수가 등록되었습니다.'
    else
      @markets = Market.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    @markets = Market.all
  end

  def update
    if @collection.update(collection_params)
      redirect_to collections_path, notice: '수거 접수가 수정되었습니다.'
    else
      @markets = Market.all
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    if @collection.update(status: params[:status])
      @collection.reload
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to collections_path, notice: '상태가 업데이트되었습니다.' }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("collection_#{@collection.id}", partial: "collection_row", locals: { collection: @collection }) }
        format.html { redirect_to collections_path, alert: '상태 업데이트에 실패했습니다.' }
      end
    end
  end

  def revert
    if @collection.completed?
      @collection.revert_to_pending!
      @collection.reload
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to collections_path, notice: '수거 상태가 접수로 되돌려졌습니다.' }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("collection_#{@collection.id}", partial: "collection_row", locals: { collection: @collection }) }
        format.html { redirect_to collections_path, alert: '완료된 수거만 되돌릴 수 있습니다.' }
      end
    end
  end

  def destroy
    @collection.destroy
    redirect_to collections_path, notice: '수거 접수가 삭제되었습니다.'
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:farm_name, :product_name, :quantity, :weight, :market_id, :receiver, :scheduled_at)
  end

  def calculate_summary(collections)
    {
      total_quantity: collections.sum(:quantity),
      completed_count: collections.completed.count,
      in_progress_count: collections.in_progress.count,
      pending_count: collections.pending.count,
      by_market: collections.group(:market_id).sum(:quantity)
    }
  end
end
