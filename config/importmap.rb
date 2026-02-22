# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "selectize.js", to: "https://ga.jspm.io/npm:selectize.js@0.12.12/dist/js/selectize.js"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@1.12.4/dist/jquery.js"
pin "microplugin", to: "https://ga.jspm.io/npm:microplugin@0.0.3/src/microplugin.js"
pin "sifter", to: "https://ga.jspm.io/npm:sifter@0.5.4/sifter.js"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.1/lib/assets/compiled/rails-ujs.js"
pin "cytoscape" # @3.33.1
pin "cytoscape-dagre", to: "https://esm.sh/cytoscape-dagre@2.5.0?external=cytoscape"
