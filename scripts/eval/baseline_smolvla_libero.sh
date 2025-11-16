export MUJOCO_GL="egl"

lerobot-eval \
  --policy.path=HuggingFaceVLA/smolvla_libero \
  --env.type=libero \
  --env.task=libero_object \
  --env.render_mode=human \
  --eval.batch_size=2 \
  --eval.n_episodes=10 \
  --policy.use_amp=false \
  --policy.device=cuda
