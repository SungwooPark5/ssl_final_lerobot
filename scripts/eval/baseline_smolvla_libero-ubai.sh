export MUJOCO_GL=egl
export PYOPENGL_PLATFORM=egl

lerobot-eval \
  --policy.path=HuggingFaceVLA/smolvla_libero \
  --env.type=libero \
  --env.task=libero_object \
  --env.render_mode=null \
  --eval.batch_size=2 \
  --eval.n_episodes=10 \
  --policy.use_amp=false \
  --policy.device=cpu
