# 직접 훈련시킨 ACT baseline 모델에 대한 검증 스크립트
# dataset: aloha_sim_trasfer_cube_human
# task: Aloha transfer cube

MUJOCO_GL=egl lerobot-eval \
  --policy.path=swpark5/acm_aloha_transfer_chunk100 \
  --policy.push_to_hub=true \
  --env.type=aloha \
  --env.task=AlohaTransferCube-v0  \
  --eval.batch_size=50 \
  --eval.n_episodes=500 \
  --policy.use_amp=false \
  --policy.device=cuda
