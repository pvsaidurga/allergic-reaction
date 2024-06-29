import os
import openai

openai.api_type = "azure"
openai.api_base = "https://openai-test-infy1.openai.azure.com/"
openai.api_version = "2024-02-01"
openai.api_key = "2977d4e5b8e649f3bcfc5ebd03b44e60"
def summerize(selectedgroups,ingre,healthreport,selected_foodOrBodyCare_items):
    messages = [
    {"role": "system", "content": "You are a helpful assistant specialized in identifying potential allergic reactions based on provided user health details and ingredients."},
    {"role": "user", "content": f"""
      Summarize details of any ingredients for selected type of item: {selected_foodOrBodyCare_items} that might cause allergic reactions or exacerbate the user's conditions based on the provided diseases and health report or allergies.
    Disease:
    {selectedgroups}
    Health report:
    {healthreport}
    Ingredients: 
    {ingre}
    """}
    ]
    response = openai.ChatCompletion.create(
        engine="gpt4",
        messages=messages,
        temperature=0,
        top_p=0.95,
        frequency_penalty=0,
        presence_penalty=0,
        stop=None
    )
    return response.choices[0]['message']['content']