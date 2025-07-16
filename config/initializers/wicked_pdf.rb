WickedPdf.config = {
  # 로컬 wkhtmltopdf 바이너리 경로 (gem에서 제공)
  exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf'),
  
  # 기본 PDF 옵션
  page_size: 'A4',
  margin: {
    top: '10mm',
    bottom: '10mm',
    left: '10mm',
    right: '10mm'
  },
  
  # 한글 폰트 지원
  encoding: 'UTF-8',
  print_media_type: true,
  
  # 웹 폰트 로딩 대기
  javascript_delay: 1000,
  no_stop_slow_scripts: true,
  
  # 출력 품질 향상
  dpi: 300,
  zoom: 1.0,
  
  # 디버깅 (개발 환경에서만)
  show_as_html: Rails.env.development?
}