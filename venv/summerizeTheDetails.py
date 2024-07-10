import os
import openai

openai.api_type = "azure"
openai.api_base = "https://openai-test-infy1.openai.azure.com/"
openai.api_version = "2024-02-01"
openai.api_key = "2977d4e5b8e649f3bcfc5ebd03b44e60"
def summerize(selectedgroups,ingre,healthreport,selected_foodOrBodyCare_items):
    messages = [
    # {"role": "system", "content": "You are a helpful assistant specialized in identifying potential allergic reactions based on provided user health details and ingredients."},
    # {"role": "user", "content": f"""
    #   Summarize details of any ingredients for selected type of item: {selected_foodOrBodyCare_items} that might cause allergic reactions or exacerbate the user's conditions based on the provided diseases and health report or allergies. At the End display the Overall Safe Percentage to buy the Product
    # Disease:
    # {selectedgroups}
    # Health report:
    # {healthreport}
    # Ingredients: 
    # {ingre}
    # The result should be display for every allergic ingredient in the form of 
    # ingredient name: value,
    # level of harm: value,
    # Recommendation: Recommended or Not Recommended,
    # summary : value,
    # Safer Percentage: value
    # """}
    # ]
    # [
    {"role": "system", "content": "You are a helpful assistant specialized in identifying potential allergic reactions based on provided user health details and ingredients."},
    {"role": "user", "content": """
      Summarize details of any ingredients for selected type of item: {selected_foodOrBodyCare_items} that might cause allergic reactions or exacerbate the user's conditions based on the provided diseases and health report or allergies.
    Disease:
    {selectedgroups}
    Health report:
    {healthreport}
    Ingredients: 
    {ingre}
    The result should be displayed for every allergic ingredient in the form of:
    ingredient name: value,
    level of harm: value,
    Recommendation: Recommended or Not Recommended,
    summary: value,
    At the end, display the Overall Safe Percentage to buy the product in the form of:
    safer percentage: value
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