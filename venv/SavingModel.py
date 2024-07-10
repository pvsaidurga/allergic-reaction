from transformers import TrOCRProcessor, VisionEncoderDecoderModel

# Initialize the processor and model
processor = TrOCRProcessor.from_pretrained("microsoft/trocr-large-handwritten")
model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-large-handwritten")

# Save the processor and model locally
processor.save_pretrained("./trocr_processor_large")
model.save_pretrained("./trocr_model_large")
