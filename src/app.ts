import { Recipe } from "@cooklang/cooklang-ts";
import { Elm } from "./Main.elm"
import recipesList from "../public/recipes.json"

async function main() {
    const app = Elm.Main.init({
        flags: {recipesList},
        node: document.getElementById("root"),
    })

    const recipes = await Promise.all(recipesList.map(async file => {
        const response = await fetch(`/recipes/${file}`)
        const body = await response.text()
        const recipe = new Recipe(body)
        const json = JSON.parse(recipe.toJSON())
        return {file, response, body, recipe, json}
    }))
    app.ports.recipes.send(recipes)
}
main()