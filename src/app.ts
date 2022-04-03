import { Recipe } from "@cooklang/cooklang-ts";
import { Elm } from "./Main.elm"
import recipesList from "../public/recipes.json"

async function main() {
    const app = Elm.Main.init({
        flags: {recipesList},
        node: document.getElementById("root"),
    })

    app.ports.recipeReq.subscribe(async req => {
        try {
            const {file} = req
            const response = await fetch(`/recipes/${file}`)
            const body = await response.text()
            const recipe = new Recipe(body)
            const json = JSON.parse(recipe.toJSON())
            app.ports.recipeRes.send({status: 'success', file, response, body, recipe, json})
        }
        catch (error) {
            app.ports.recipeRes.send({status: 'error', error})
        }
    })
}
main()