// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import VoiceController from "./voice_controller"

// 음성 컨트롤러 수동 등록
application.register("voice", VoiceController)

eagerLoadControllersFrom("controllers", application)
