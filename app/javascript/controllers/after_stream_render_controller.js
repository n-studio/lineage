import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    let afterStreamRenderEvent = new CustomEvent("turbo:after-stream-render", {
      bubbles: true,
      cancelable: true,
    });
    document.body.dispatchEvent(afterStreamRenderEvent);
  }
}
