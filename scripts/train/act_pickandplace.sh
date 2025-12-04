HF_USER=swpark5
DATASET_PATH=so101_pickandplace
MUJOCO_GL=egl

CHUNK=100
STEP=100

log_path="./logs"


echo "Start scheduled training" 
echo "You can check progress with: tail -f ./logs/acm_pickandplace.log"

nohup lerobot-train \
  --dataset.repo_id=${HF_USER}/${DATASET_PATH} \
  --policy.type=acm \
  --job_name=acm_pickandplace_chunk${CHUNK}_step${STEP} \
  --policy.repo_id=${HF_USER}/acm_pickandplace_chunk${CHUNK}_step${STEP} \
  --policy.device=cuda \
  --policy.use_mamba=true \
  --wandb.enable=true > "${log_path}/acm_pickandplace.log" 2>&1 &

nohup lerobot-train \
  --dataset.repo_id=${HF_USER}/${DATASET_PATH} \
  --policy.type=act \
  --job_name=act_pickandplace_chunk${CHUNK}_step${STEP} \
  --policy.repo_id=${HF_USER}/act_pickandplace_chunk${CHUNK}_step${STEP} \
  --policy.device=cuda \
  --policy.use_mamba=false \
  --wandb.enable=true > "${log_path}/act_pickandplace.log" 2>&1 &
