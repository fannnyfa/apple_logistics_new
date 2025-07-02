# 테스트 데이터 생성 스크립트

# 기존 데이터 확인
puts "현재 공판장 수: #{Market.count}"
puts "현재 수거 예약 수: #{Collection.count}"

# 샘플 수거 예약 데이터 생성
markets = Market.all
receivers = ['A', 'B']
statuses = ['pending', 'in_progress', 'completed']

# 오늘 데이터
today = Date.current
10.times do |i|
  Collection.create!(
    farm_name: "농장#{i + 1}",
    quantity: rand(10..100),
    market: markets.sample,
    receiver: receivers.sample,
    scheduled_at: today + rand(-2..2).hours + rand(0..59).minutes,
    status: statuses.sample
  )
end

# 어제 데이터
yesterday = Date.current - 1.day
8.times do |i|
  Collection.create!(
    farm_name: "어제농장#{i + 1}",
    quantity: rand(15..80),
    market: markets.sample,
    receiver: receivers.sample,
    scheduled_at: yesterday + rand(8..18).hours + rand(0..59).minutes,
    status: ['completed', 'completed', 'in_progress'].sample
  )
end

# 내일 데이터
tomorrow = Date.current + 1.day
5.times do |i|
  Collection.create!(
    farm_name: "내일농장#{i + 1}",
    quantity: rand(20..120),
    market: markets.sample,
    receiver: receivers.sample,
    scheduled_at: tomorrow + rand(9..17).hours + rand(0..59).minutes,
    status: 'pending'
  )
end

puts "\n테스트 데이터 생성 완료!"
puts "총 수거 예약: #{Collection.count}개"
puts "오늘: #{Collection.today.count}개"
puts "- 대기: #{Collection.today.pending.count}개"
puts "- 진행중: #{Collection.today.in_progress.count}개"  
puts "- 완료: #{Collection.today.completed.count}개"