# 직접 훈련시킨 ACT baseline 모델에 대한 검증 스크립트
# dataset: aloha_sim_trasfer_cube_human
# task: Aloha transfer cube

lerobot-eval \
  --policy.path=swpark5/baseline_act_aloha_sim_transfer_cube_80k \
  --policy.push_to_hub=true \
  --policy.repo_id=swpark5/eval_baseline_act_aloha_sim_transfer_cube_80k \
  --env.type=aloha \
  --env.task=AlohaTransferCube-v0  \
  --eval.batch_size=1 \
  --eval.n_episodes=1 \
  --policy.use_amp=false \
  --policy.device=cuda
