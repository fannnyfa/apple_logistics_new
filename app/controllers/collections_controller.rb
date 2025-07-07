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
    @date = params[:date]&.to_date || Date.current
    @collections = Collection.includes(:market).by_date(@date)
    
    # 필터 적용
    @collections = @collections.where(market_id: params[:market_id]) if params[:market_id].present?
    @collections = @collections.where(status: params[:status]) if params[:status].present?
    @collections = @collections.where("receiver ILIKE ?", "%#{params[:receiver]}%") if params[:receiver].present?
    
    @collections = @collections.order(:scheduled_at)
    @markets = Market.all
    @summary = calculate_summary(@collections)
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
    params.require(:collection).permit(:farm_name, :quantity, :market_id, :receiver, :scheduled_at)
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
