import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static values = {
    searchId: Number,
    url: String
  }
  
  connect() {
    this.connectToSSE()
  }
  
  disconnect() {
    this.disconnectFromSSE()
  }
  
  connectToSSE() {
    if (this.eventSource) {
      this.eventSource.close()
    }
    
    const url = this.urlValue || `/searches/${this.searchIdValue}/stream`
    this.eventSource = new EventSource(url)
    
    this.eventSource.addEventListener('turbo-stream', (event) => {
      Turbo.renderStreamMessage(event.data)
    })
    
    this.eventSource.onerror = () => {
      console.error('SSE connection error')
      this.eventSource.close()
    }
  }
  
  disconnectFromSSE() {
    if (this.eventSource) {
      this.eventSource.close()
      this.eventSource = null
    }
  }
}