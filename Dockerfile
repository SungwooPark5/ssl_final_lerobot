FROM huggingface/lerobot-gpu:latest

# root user for apt-get installation
USER root

# Install GCloud CLI to upload outputs
RUN apt-get update && apt-get install -y curl gnupg lsb-release \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && apt-get update && apt-get install -y google-cloud-sdk \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Optional installation for custom lerobot repo
# RUN pip install "lerobot[aloha] @ git+https://github.com/SungwooPark5/lerobot-ac-mlp.git@main"

COPY . .

CMD ["bash"]
