import { Controller } from "@hotwired/stimulus"

// 음성 인식 기능을 처리하는 Stimulus 컨트롤러
export default class extends Controller {
  
  // 음성 인식 시작 메서드
  start() {
    console.log("🎤 음성입력 버튼 클릭됨")
    
    // 브라우저의 Web Speech API 지원 여부 확인
    const Recognition = window.SpeechRecognition || window.webkitSpeechRecognition
    
    if (!Recognition) {
      console.log("❌ 음성 인식 미지원 브라우저")
      alert("이 브라우저는 음성 인식을 지원하지 않습니다")
      return
    }
    
    console.log("✅ 음성 인식 API 사용 가능")
    
    // 음성 인식 객체 생성 및 설정
    const recognition = new Recognition()
    recognition.lang = 'ko-KR'  // 한국어로 설정
    recognition.interimResults = false  // 최종 결과만 받기
    recognition.continuous = false  // 한 번만 인식
    recognition.maxAlternatives = 1  // 최상위 결과만 받기
    
    // 음성 인식 시작 이벤트
    recognition.onstart = () => {
      console.log("🎙️ 음성 인식 시작됨 - 말씀해 주세요!")
    }
    
    // 음성 인식 결과 처리
    recognition.onresult = (event) => {
      const transcript = event.results[0][0].transcript
      console.log("📝 인식된 텍스트:", transcript)
      
      // 인식된 텍스트를 각 입력 필드에 자동 입력
      this.fillFormFields(transcript)
    }
    
    // 음성 인식 종료 이벤트
    recognition.onspeechend = () => {
      console.log("🔇 음성 인식 종료됨")
      recognition.stop()
    }
    
    // 음성 인식 에러 처리
    recognition.onerror = (event) => {
      console.error("❌ 음성 인식 오류:", event.error)
      
      let errorMessage = "음성 인식 중 오류가 발생했습니다"
      switch(event.error) {
        case 'no-speech':
          errorMessage = "음성이 감지되지 않았습니다. 다시 시도해 주세요"
          break
        case 'audio-capture':
          errorMessage = "마이크에 접근할 수 없습니다. 브라우저 권한을 확인해 주세요"
          break
        case 'not-allowed':
          errorMessage = "마이크 사용 권한이 거부되었습니다. 브라우저 설정을 확인해 주세요"
          break
      }
      
      alert(errorMessage)
    }
    
    // 음성 인식 시작
    try {
      recognition.start()
      console.log("🚀 음성 인식 시작 시도...")
    } catch (error) {
      console.error("❌ 음성 인식 시작 실패:", error)
      alert("음성 인식을 시작할 수 없습니다")
    }
  }
  
  // 인식된 텍스트를 분석하여 각 입력 필드에 자동 입력
  fillFormFields(transcript) {
    console.log("📋 필드 자동 입력 시작:", transcript)
    
    // 1. 생산자 이름 추출 (숫자 나오기 전 첫 단어들)
    this.fillFarmName(transcript)
    
    // 2. 품명 설정 (기본값 "사과")
    this.fillProductName(transcript)
    
    // 3. 수량 추출 (숫자 부분)
    this.fillQuantity(transcript)
    
    // 4. 무게 설정 (5킬로 언급 시 5kg, 아니면 10kg)
    this.fillWeight(transcript)
    
    // 5. 공판장 자동 선택 (부분 일치)
    this.fillMarket(transcript)
    
    console.log("✅ 필드 자동 입력 완료")
  }
  
  // 생산자 이름 필드 채우기
  fillFarmName(transcript) {
    const farmNameField = document.getElementById('collection_farm_name')
    if (!farmNameField) {
      console.log("❌ 생산자 이름 필드를 찾을 수 없음")
      return
    }
    
    // 숫자 나오기 전까지의 첫 단어들을 이름으로 간주
    const farmNameMatch = transcript.match(/^([^\d]+?)(?=\d|$)/)
    if (farmNameMatch) {
      const farmName = farmNameMatch[1].trim()
      if (farmName) {
        farmNameField.value = farmName
        console.log("👤 생산자 이름 설정:", farmName)
      }
    }
  }
  
  // 품명 필드 채우기
  fillProductName(transcript) {
    const productNameField = document.getElementById('collection_product_name')
    if (!productNameField) {
      console.log("❌ 품명 필드를 찾을 수 없음")
      return
    }
    
    // 현재는 사과만 지원하므로 기본값 유지
    // 추후 다른 과일명 추가 시 여기서 처리
    productNameField.value = '사과'
    console.log("🍎 품명 설정: 사과 (기본값)")
  }
  
  // 수량 필드 채우기
  fillQuantity(transcript) {
    const quantityField = document.getElementById('collection_quantity')
    if (!quantityField) {
      console.log("❌ 수량 필드를 찾을 수 없음")
      return
    }
    
    // 숫자 추출 (예: "20개" → 20)
    const quantityMatch = transcript.match(/(\d+)/)
    if (quantityMatch) {
      const quantity = quantityMatch[1]
      quantityField.value = quantity
      console.log("🔢 수량 설정:", quantity)
    }
  }
  
  // 무게 필드 채우기
  fillWeight(transcript) {
    const weightField = document.getElementById('collection_weight')
    if (!weightField) {
      console.log("❌ 무게 필드를 찾을 수 없음")
      return
    }
    
    // "5", "오", "다섯", "5킬로", "5kg" 등 5kg 관련 키워드 확인
    const hasFiveKg = /5|오|다섯|5킬로|5kg|오킬로|다섯킬로/.test(transcript)
    const selectedWeight = hasFiveKg ? '5kg' : '10kg'
    
    weightField.value = selectedWeight
    console.log("⚖️ 무게 설정:", selectedWeight)
  }
  
  // 공판장 필드 채우기
  fillMarket(transcript) {
    const marketField = document.getElementById('collection_market_id')
    if (!marketField) {
      console.log("❌ 공판장 필드를 찾을 수 없음")
      return
    }
    
    const options = Array.from(marketField.options)
    console.log("🏪 공판장 옵션 검사 중...", options.length + "개")
    
    // 각 옵션의 텍스트와 음성 입력 비교
    for (let option of options) {
      if (option.text && option.text !== '공판장을 선택하세요') {
        // 옵션 텍스트의 각 단어를 검사
        const optionWords = option.text.split(/\s+/)
        const foundMatch = optionWords.some(word => {
          // 한 글자 단어는 제외하고 부분 일치 검사
          return word.length > 1 && transcript.includes(word)
        })
        
        if (foundMatch) {
          marketField.value = option.value
          console.log("🏪 공판장 설정:", option.text)
          break
        }
      }
    }
  }
}