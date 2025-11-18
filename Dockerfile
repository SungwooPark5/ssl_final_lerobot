FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-devel

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    # --- 빌드/소스용 ---
    git \
    cmake \
    build-essential \
    pkg-config \
    \
    # --- 렌더링용 (egl-probe -> egl-utils) ---
    libgl1-mesa-glx \
    mesa-utils \
    \
    # --- 비디오용 (conda install ffmpeg -> apt) ---
    ffmpeg \
    libavformat-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavutil-dev \
    libswscale-dev \
    libswresample-dev \
    libavfilter-dev \
    \
    # --- GCloud (GCS 업로드용) ---
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && apt-get update && apt-get install -y google-cloud-sdk \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

RUN pip install --upgrade pip
RUN pip install "lerobot[aloha] @ git+https://github.com/SungwooPark5/lerobot-ac-mlp.git@main"
RUN pip install PyOpenGL PyOpenGL_accelerate

COPY . .

CMD ["bash"]
