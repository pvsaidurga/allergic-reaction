import os
import openai
from transformers import TrOCRProcessor, VisionEncoderDecoderModel
from test4 import process_image
from transformers.models.auto import image_processing_auto


openai.api_type = "azure"
openai.api_base = "https://openai-test-infy1.openai.azure.com/"
openai.api_version = "2024-02-01"
openai.api_key = "2977d4e5b8e649f3bcfc5ebd03b44e60"
def extract_ingredients(text):
    print(text)
    messages = [
    {"role": "user", "content": f"Extract ingredient details from the following text:\n\n{text}"}
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

def extract_health_records(text):
    print(text)
    messages=[
        {
         "role": "user", "content": f"""Extract the following health record details from the text: {text} 
        Format the output as: age value, height value, weight value, blood group value, haemoglobin value, rbc count value, wbc count value, platelet count value. if a value is not present then replace that value with null """
        }
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

def extract_health_prescriptions(file_path):  
    processor = TrOCRProcessor.from_pretrained("./trocr_processor_large")
    model = VisionEncoderDecoderModel.from_pretrained("./trocr_model_large")   
    page_text = process_image(file_path, processor, model)   
    return page_text
