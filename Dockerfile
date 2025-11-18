FROM huggingface/lerobot-gpu:latest

WORKDIR /workspace

COPY . .

CMD ["bash"]
