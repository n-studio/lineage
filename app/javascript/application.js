// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import $ from "jquery"
import "selectize.js"
import Rails from "@rails/ujs"
Rails.start()

const ready = () => {
  $("input[data-select-practitioner]").selectize({
    valueField: "id",
    labelField: "name",
    searchField: "name",
    create: true,
    render: {
      option: function (item, escape) {
        return (
          "<div>" +
          '<span class="title">' +
          '<span class="name">' +
          escape(item.name) +
          "</span>" +
          "</span>" +
          "</div>"
        )
      },
    },
    load: function (query, callback) {
      if (!query.length) return callback()
      $.ajax({
        url: "/practitioners/search/" + encodeURIComponent(query) + ".json",
        type: "GET",
        error: function () {
          callback()
        },
        success: function (res) {
          callback(res.data.slice(0, 10))
        },
      })
    },
  })

  $("select[data-select-style]").selectize({
    valueField: "id",
    labelField: "name",
    searchField: "name",
    sortField: "text",
    create: true,
    render: {
      option: function (item, escape) {
        return (
          "<div>" +
          '<span class="title">' +
          '<span class="name">' +
          escape(item.name) +
          "</span>" +
          "</span>" +
          "</div>"
        )
      },
    },
    load: function (query, callback) {
      if (!query.length) return callback()
      $.ajax({
        url: "/styles/search/" + encodeURIComponent(query) + ".json",
        type: "GET",
        error: function () {
          callback()
        },
        success: function (res) {
          callback(res.data.slice(0, 10))
        },
      })
    },
  })
}

document.addEventListener("turbo:load", function() {
  ready()
})

document.addEventListener("turbo:frame-render", function() {
  ready()
})

document.addEventListener("turbo:after-stream-render", function() {
  ready()
})
