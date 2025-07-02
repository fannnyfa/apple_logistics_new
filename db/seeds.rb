# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# 공판장 데이터 시드
markets_data = [
  { name: "엄궁농협공판장", location: "엄궁농협공판장", district: "엄궁동" },
  { name: "항도청과", location: "항도청과", district: "엄궁동" },
  { name: "부산청과", location: "부산청과", district: "엄궁동" },
  { name: "반여농협공판장", location: "반여농협공판장", district: "반여동" },
  { name: "중앙청과", location: "중앙청과", district: "반여동" },
  { name: "동부청과", location: "동부청과", district: "반여동" }
]

markets_data.each do |market_data|
  Market.find_or_create_by!(name: market_data[:name]) do |market|
    market.location = market_data[:location]
    market.district = market_data[:district]
  end
end

puts "공판장 데이터 시드 완료: #{Market.count}개 공판장"
