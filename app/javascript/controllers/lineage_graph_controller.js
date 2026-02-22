import { Controller } from "@hotwired/stimulus"
import cytoscape from "cytoscape"
import cytoscapeDagre from "cytoscape-dagre"

cytoscapeDagre(cytoscape)

const FIXED_ZOOM = 1.2

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    graph: Object,
    practitionerPathTemplate: String
  }

  connect() {
    this.renderGraph()
  }

  resetZoom() {
    if (this.cy) {
      this.centerOnCurrent(this.canvasTarget)
    }
  }

  disconnect() {
    if (this.cy) {
      this.cy.destroy()
      this.cy = null
    }
  }

  renderGraph() {
    const data = this.graphValue
    if (!data || !data.nodes || data.nodes.length === 0) return

    const elements = []

    data.nodes.forEach(node => {
      elements.push({
        group: "nodes",
        data: {
          id: node.id,
          label: node.name,
          isCurrent: String(node.id) === String(data.current_id)
        }
      })
    })

    data.edges.forEach(edge => {
      elements.push({
        group: "edges",
        data: {
          id: `${edge.source}-${edge.target}`,
          source: edge.source,
          target: edge.target
        }
      })
    })

    this.cy = cytoscape({
      container: this.canvasTarget,
      elements: elements,
      style: [
        {
          selector: "node",
          style: {
            "label": "data(label)",
            "text-valign": "center",
            "text-halign": "center",
            "background-color": "#ffffff",
            "border-width": 1,
            "border-color": "#cccccc",
            "shape": "roundrectangle",
            "width": "label",
            "height": "label",
            "padding": "10px",
            "font-size": "11px",
            "font-family": "Arial, Verdana, Tahoma",
            "color": "#666666",
            "text-wrap": "wrap",
            "text-max-width": "120px"
          }
        },
        {
          selector: "node[?isCurrent]",
          style: {
            "font-weight": "bold",
            "border-width": 2,
            "border-color": "#94a0b4"
          }
        },
        {
          selector: "edge",
          style: {
            "width": 1,
            "line-color": "#cccccc",
            "target-arrow-color": "#cccccc",
            "target-arrow-shape": "triangle",
            "curve-style": "taxi",
            "taxi-direction": "downward",
            "arrow-scale": 0.8
          }
        }
      ],
      layout: {
        name: "dagre",
        rankDir: "TB",
        nodeSep: 50,
        rankSep: 70,
        edgeSep: 10,
        animate: false,
        fit: false
      },
      userZoomingEnabled: true,
      userPanningEnabled: true,
      boxSelectionEnabled: false,
      autoungrabify: true
    })

    this.centerOnCurrent(this.canvasTarget)

    this.cy.on("tap", "node", (evt) => {
      const nodeId = evt.target.id()
      const path = this.practitionerPathTemplateValue.replace(":id", nodeId)
      const frame = document.querySelector("turbo-frame#practitioner_info")
      if (frame) {
        frame.src = path
      }
    })

    this.cy.on("mouseover", "node", (evt) => {
      evt.target.style({
        "background-color": "#c8e4f8",
        "color": "#000000",
        "border-color": "#94a0b4"
      })
      this.canvasTarget.style.cursor = "pointer"
    })

    this.cy.on("mouseout", "node", (evt) => {
      const isCurrent = evt.target.data("isCurrent")
      evt.target.style({
        "background-color": "#ffffff",
        "color": "#666666",
        "border-color": isCurrent ? "#94a0b4" : "#cccccc"
      })
      this.canvasTarget.style.cursor = "default"
    })
  }

  centerOnCurrent(container) {
    const currentNode = this.cy.nodes("[?isCurrent]")
    if (currentNode.length === 0) return

    const containerHeight = container.clientHeight

    this.cy.zoom(FIXED_ZOOM)

    const pos = currentNode.position()
    const pan = {
      x: (container.clientWidth / 2) - pos.x * FIXED_ZOOM,
      y: containerHeight - containerHeight * 0.15 - pos.y * FIXED_ZOOM
    }
    this.cy.pan(pan)
  }
}
