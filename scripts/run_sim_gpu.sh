set -e

export MUJOCO_GL=egl
python -m lerobot.rl.gym_manipulator --config_path configs/keyboard_sim_gpu.json
