const app = Elm.Main.init()

fetch('/dist/recipes.json')
    .then(res => res.json())
    // .then(data => {console.log('success', data); return data})
    .then(data => app.ports.recipes.send({ status: 'success', data }))
    .catch(error => app.ports.recipes.send({ status: 'error', error }))