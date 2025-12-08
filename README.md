## Port and ID
ID: your_leader_arm_id (e.g., so101_leader)
leader: your_leader_arm_port (e.g., /dev/ttyACM1)

ID: your_follower_arm_id (e.g., so101_follower)
follwer: your_follower_arm_port (e.g., /dev/ttyACM0)

Top Cam
port: your_cam1_port (e.g., /dev/video0)

Front Cam
port: your_cam2_port (e.g., /dev/video2)

## Calibration
lerobot-calibrate \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyACM0 \
    --robot.id=so101_follower 
    
lerobot-calibrate \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyACM1 \
    --teleop.id=so101_leader 

## Teleoperation
### Teleoperation without Cams
lerobot-teleoperate \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyACM0 \
    --robot.id=so101_follower \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyACM2 \
    --teleop.id=so101_leader
    
### Teleoperation with Cams
lerobot-teleoperate \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyACM0 \
    --robot.id=so101_follower \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyACM1 \
    --teleop.id=so101_leader \
    --robot.cameras="{ front: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}, top: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}}" \
    --display_data=true

## Collect Dataset
lerobot-record \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyACM0 \
    --robot.id=so101_follower \
    --robot.cameras="{ front: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}, top: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}}" \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyACM1 \
    --teleop.id=so101_leader \
    --display_data=true \
    --dataset.repo_id=swpark5/so101_pickandplace_v3 \
    --dataset.num_episodes=50 \
    --dataset.single_task="Grab the wooden cube and place it to a black box"
    
## Real World Evaluation
### ACM, Action Chunking with Mamba
lerobot-record  \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=so101_follower \
  --robot.cameras="{ front: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}, top: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}}" \
  --display_data=true \
  --dataset.repo_id=swpark5/eval_acm_pickandplace_v3 \
  --dataset.single_task="Grab the wooden cube and place it to a black box" \
  --dataset.num_episodes=50 \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM1 \
  --teleop.id=so101_leader \
  --policy.path=swpark5/acm_pickandplace_chunk100_step100_v3 \
  --policy.use_mamba=true
  
### ACT, Action Chunking with Transformer
lerobot-record  \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=so101_follower \
  --robot.cameras="{ front: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}, top: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}}" \
  --display_data=true \
  --dataset.repo_id=swpark5/eval_act_pickandplace_v3 \
  --dataset.single_task="Grab the wooden cube and place it to a black box" \
  --dataset.num_episodes=50 \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM1 \
  --teleop.id=so101_leader \
  --policy.path=swpark5/act_pickandplace_chunk100_step100_v3 
  
### SmolVLA
lerobot-record  \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=so101_follower \
  --robot.cameras="{ camera1: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}, camera2: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}}" \
  --display_data=true \
  --dataset.repo_id=swpark5/eval_smolvla_pickandplace_v3 \
  --dataset.single_task="Grab the wooden cube and place it to a black box" \
  --dataset.num_episodes=50 \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM1 \
  --teleop.id=so101_leader \
  --policy.path=swpark5/smolvla_pickandplace__v3
  
### SmolVLA with Async. Inference
python -m lerobot.async_inference.policy_server \
     --host=127.0.0.1 \
     --port=8080
  
python -m lerobot.async_inference.robot_client \
  --server_address=127.0.0.1 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=so101_follower \
  --robot.cameras="{ camera1: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}, camera2: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}}" \
  --display_data=true \
  --dataset.repo_id=swpark5/eval_smolvla_pickandplace_v3 \
  --task="Grab the wooden cube and place it to a black box" \
  --dataset.num_episodes=50 \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM1 \
  --teleop.id=so101_leader \
  --policy.path=swpark5/smolvla_pickandplace_chunk100_step100_v3
  
