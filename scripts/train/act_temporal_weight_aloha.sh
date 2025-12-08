#!/bin/bash

# ====================================================
# 1. 하이퍼파라미터 정의
# ====================================================
CHUNKS=(200 400)

STEPS=(1 10 50 100)

# 사용할 GPU 개수
NUM_GPUS=4

# 임시 실행 파일들을 저장할 디렉토리 생성
mkdir -p ./sched_scripts
rm -f ./sched_scripts/run_gpu_*.sh

# ====================================================
# 2. 작업 분배 (Round Robin 방식)
# ====================================================
count=0

for chunk in "${CHUNKS[@]}"; do
    for step in "${STEPS[@]}"; do
	
	if [ $step -gt $chunk ]; then
		echo "WARNING: Skipping invalid combination: chunk=${chunk}, step=${step}, Step>Chunk"
		continue
	fi

        # 현재 작업을 할당할 GPU ID 계산 (0, 1, 2, 3 순환)
        gpu_id=$((count % NUM_GPUS))

        # 각 GPU별 실행 스크립트 파일명
        script_file="./sched_scripts/run_gpu_${gpu_id}.sh"

        # 실험 이름 (구분을 위해 파라미터 포함)
        job_name="act_temporal_weight_aloha_transfer_chunk${chunk}_step${step}"

        # 첫 번째 라인에 shebang 추가 (파일이 처음 생성될 때만)
        if [ ! -f "$script_file" ]; then
            echo "#!/bin/bash" >"$script_file"
        fi

        # ----------------------------------------------------
        # 실행 명령어 추가 (>> 를 사용하여 파일 끝에 추가)
        # ----------------------------------------------------
        # 실제 실행 명령어 (줄바꿈 없이 한 줄로 작성하거나, 역슬래시 처리 주의)
	cat >>"$script_file" <<EOF
        echo "[Start] Job: ${job_name} on GPU ${gpu_id}"

	unset DISPLAY

	export EGL_DEVICE_ID=${gpu_id}
	export MUJOCO_EGL_DEVICE=${gpu_id}

        CUDA_VISIBLE_DEVICES=${gpu_id} MUJOCO_GL=egl lerobot-train \
          --policy.type=acm \
          --policy.repo_id=swpark5/${job_name} \
          --policy.push_to_hub=true \
          --policy.device=cuda \
          --dataset.repo_id=lerobot/aloha_sim_transfer_cube_human \
          --env.type=aloha \
          --env.task=AlohaTransferCube-v0 \
          --steps=200000 \
          --batch_size=8 \
          --eval.batch_size=10 \
          --eval.n_episodes=50 \
          --eval_freq=10000 \
          --log_freq=100 \
          --save_freq=10000 \
          --job_name=${job_name} \
          --wandb.enable=true \
	  --policy.chunk_size=${chunk} \
	  --policy.n_action_steps=${step} \
	  --policy.use_mamba=false \
	  --policy.use_temporal_weighting=true

        echo "[Done] Job: ${job_name} finished."
        sleep 5 # 작업 간 5초 휴식
EOF

        ((count++))
    done
done

# ====================================================
# 3. 생성된 스크립트 병렬 실행
# ====================================================
echo "총 ${count}개의 실험이 ${NUM_GPUS}개의 GPU에 분배되었습니다."

for ((id = 0; id < NUM_GPUS; id++)); do
    script_file="./sched_scripts/run_gpu_${id}.sh"

    # 실행 권한 부여
    chmod +x "$script_file"

    # 로그 파일명
    log_file="./sched_scripts/log_gpu_${id}.txt"

    echo "GPU ${id} 작업을 백그라운드에서 시작합니다... Logs: ${log_file}"

    # nohup으로 백그라운드 실행
    nohup "$script_file" >"$log_file" 2>&1 &
done

echo "모든 스케줄링이 완료되었습니다." 
echo "확인 방법: tail -f ./sched_scripts/log_gpu_0.txt"

