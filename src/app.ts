declare let Elm: any

async function fetchRecipes(): Promise<object> {
    try {
        const res = await fetch('/dist/recipes.json')
        const data = await res.json()
        return { status: 'success', data }
    }
    catch (error) {
        return { status: 'error', error }
    }
}

async function main(): Promise<void> {
    const app = Elm.Main.init()
    app.ports.recipes.send(await fetchRecipes())
}
main().catch(e => {
    console.error(e)
})
