FROM huggingface/lerobot-gpu:latest

# 1. root 권한 획득 (apt-get 설치를 위해 필수)
USER root

# 2. 시스템 의존성 설치 (GCloud CLI + 렌더링 라이브러리)
# - gcloud: 결과 업로드용
# - libglew-dev, libgl1-mesa-dev 등: MuJoCo/PyOpenGL이 EGL을 통해 GPU에 접근하기 위해 필수
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg lsb-release \
    libgl1-mesa-glx \
    mesa-utils \
    libegl1 \
    libopengl0 \
    libglew-dev \
    libosmesa6-dev \
    libgl1-mesa-dev \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && apt-get update && apt-get install -y google-cloud-sdk \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# 3. PyOpenGL 파이썬 패키지 설치
ENV PATH="/lerobot/.venv/bin:$PATH"

RUN uv pip install --upgrade pip
RUN uv pip install PyOpenGL PyOpenGL_accelerate

# RUN pip install "lerobot[aloha] @ git+https://github.com/SungwooPark5/lerobot-ac-mlp.git@main"

# 5. 평가 스크립트 복사

COPY . .

CMD ["bash"]
