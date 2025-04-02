# export OMP_NUM_THREADS=8
# export NCCL_IB_DISABLE=0
# export NCCL_IB_GID_INDEX=3
# export NCCL_SOCKET_IFNAME=br-intranet
# export NCCL_DEBUG=INFO

# export ACCELERATE_CPU_AFFINITY=1 
# export NPROC_PER_NODE=8
# export NODES=1 
# export NODE_RANK=0 
# export MASTER_ADDR=172.17.100.112 
# export MASTER_PORT=23456 
# export RUN_NAME=llava-onevision-google-siglip-so400m-patch14-384-lmms-lab-llava-onevision-qwen2-7b-si-ewc-stage-lambda-1
# export OUTPUT_DIR=/blob/weiwei/llava_checkpoint/$RUN_NAME
# export RUN_NAME="llava-onevision-google-siglip-so400m-patch14-384-lmms-lab-llava-onevision-qwen2-7b-si-ewc-stage-lambda-1"
# export OUTPUT_DIR="/blob/weiwei/llava_checkpoint/$RUN_NAME"
# export PREV_STAGE_CHECKPOINT="lmms-lab/llava-onevision-qwen2-7b-si"
# export VISION_MODEL_VERSION="google/siglip-so400m-patch14-384"

# - export OMP_NUM_THREADS=7
export NCCL_IB_DISABLE=1
# - export NCCL_IB_GID_INDEX=3
# - export NCCL_SOCKET_IFNAME="eth0"
export NCCL_DEBUG=INFO
export ACCELERATE_CPU_AFFINITY=1 
export NPROC_PER_NODE=4
export NODES=1 
export NODE_RANK=0 
# export WORLD_SIZE=4
# - export MASTER_ADDR="10.36.38.89"
# - export MASTER_PORT="23456"

# export RUN_NAME="llava-onevision-google-siglip-so400m-patch14-384-lmms-lab-llava-onevision-qwen2-7b-si-ewc-lambda01-amazon-multisource-all"
# export OUTPUT_DIR="/blob/weiwei/llava_checkpoint/llava-onevision-google-siglip-so400m-patch14-384-lmms-lab-llava-onevision-qwen2-7b-si-ewc-lambda01-amazon-multisource-all"
# export PREV_STAGE_CHECKPOINT="lmms-lab/llava-onevision-qwen2-7b-si"

# LLM_VERSION="lmms-lab/llava-onevision-qwen2-7b-si" 
# for 7b model we recommend bs=1, accum=2, 16 nodes, 128 gpus, lr=1e-5, warmup=0.03
# for 72b model we recommend bs=1, accum=1, 32 nodes, 256 gpus, lr=1e-5, warmup=0.03
LLM_VERSION_CLEAN="${LLM_VERSION//\//_}"
VISION_MODEL_VERSION="google/siglip-so400m-patch14-384"
VISION_MODEL_VERSION_CLEAN="${VISION_MODEL_VERSION//\//_}"
# RANK=${RANK:-0}
# PORT=${PORT:-12345} 
# NUM_GPUS=${NUM_GPUS:5}
# NNODES=${NNODES:1}

############### Pretrain ################

BASE_RUN_NAME="llavanext-google_siglip-so400m-patch14-384-Qwen_Qwen2-7B-Instruct-mlp2x_gelu-pretrain_blip558k_plain"
echo "BASE_RUN_NAME: ${BASE_RUN_NAME}"

############### Finetune ################

# Stage 2
PROMPT_VERSION="qwen_1_5"
# RUN_NAME="llava-onevision-${VISION_MODEL_VERSION_CLEAN}-${LLM_VERSION_CLEAN}-ewc-stage-lambda-1" 
PREV_STAGE_CHECKPOINT="lmms-lab/llava-onevision-qwen2-7b-si" # replace it with your last checkpoint training from single image collection
echo "PREV_STAGE_CHECKPOINT: ${PREV_STAGE_CHECKPOINT}"
echo "MID_RUN_NAME: ${RUN_NAME}"

# ACCELERATE_CPU_AFFINITY=1 torchrun --nproc_per_node 8 --nnodes 1 --node_rank 0 --master_addr 172.17.100.112 --master_port 23456 \
ACCELERATE_CPU_AFFINITY=1 torchrun --nproc_per_node $NPROC_PER_NODE --nnodes $NODES --node_rank $NODE_RANK --master_addr $MASTER_ADDR --master_port $MASTER_PORT \
    llava/train/train_mem.py \
    --lora_enable True \
    --deepspeed scripts/zero3.json \
    --model_name_or_path $PREV_STAGE_CHECKPOINT \
    --version $PROMPT_VERSION \
    --data_path "./msdata/split/split_small/{meta_All_Beauty_details_sftdata_att_train_1800,meta_All_Beauty_feature_sftdata_att_train_1800,meta_All_Beauty_main_category_sftdata_att_train_1800,meta_All_Beauty_price_sftdata_att_train_1800,meta_All_Beauty_Store_sftdata_att_train_1800,meta_All_Beauty_title_sftdata_att_train_1800,meta_Amazon_Fashion_description_sftdata_att_train_180,meta_Amazon_Fashion_details_sftdata_att_train_1800,meta_Amazon_Fashion_feature_sftdata_att_train_180,meta_Amazon_Fashion_main_category_sftdata_att_train_180,meta_Amazon_Fashion_price_sftdata_att_train_0,meta_Amazon_Fashion_Store_sftdata_att_train_180,meta_Amazon_Fashion_title_sftdata_att_train_180,meta_Appliances_description_sftdata_att_train_180,meta_Appliances_details_sftdata_att_train_1800,meta_Appliances_feature_sftdata_att_train_180,meta_Appliances_main_category_sftdata_att_train_180,meta_Appliances_price_sftdata_att_train_30,meta_Appliances_Store_sftdata_att_train_180,meta_Appliances_title_sftdata_att_train_1800,meta_Arts_Crafts_and_Sewing_description_sftdata_att_train_1800,meta_Arts_Crafts_and_Sewing_details_sftdata_att_train_1800,meta_Arts_Crafts_and_Sewing_feature_sftdata_att_train_1800,meta_Arts_Crafts_and_Sewing_main_category_sftdata_att_train_1800,meta_Arts_Crafts_and_Sewing_price_sftdata_att_train_1800,meta_Arts_Crafts_and_Sewing_Store_sftdata_att_train_1800,meta_Arts_Crafts_and_Sewing_title_sftdata_att_train_180,meta_Automotive_description_sftdata_att_train_180,meta_Automotive_details_sftdata_att_train_180,meta_Automotive_feature_sftdata_att_train_180,meta_Automotive_main_category_sftdata_att_train_180,meta_Automotive_price_sftdata_att_train_0,meta_Automotive_Store_sftdata_att_train_180,meta_Automotive_title_sftdata_att_train_180,meta_Baby_Products_description_sftdata_att_train_180,meta_Baby_Products_details_sftdata_att_train_1800,meta_Baby_Products_feature_sftdata_att_train_180,meta_Baby_Products_main_category_sftdata_att_train_180,meta_Baby_Products_price_sftdata_att_train_180,meta_Baby_Products_Store_sftdata_att_train_180,meta_Baby_Products_title_sftdata_att_train_1800,meta_Beauty_and_Personal_Care_description_sftdata_att_train_180,meta_Beauty_and_Personal_Care_details_sftdata_att_train_1800,meta_Beauty_and_Personal_Care_feature_sftdata_att_train_180,meta_Beauty_and_Personal_Care_main_category_sftdata_att_train_180,meta_Beauty_and_Personal_Care_price_sftdata_att_train_80,meta_Beauty_and_Personal_Care_Store_sftdata_att_train_180,meta_Beauty_and_Personal_Care_title_sftdata_att_train_1800,meta_Books_description_sftdata_att_train_1800,meta_Books_details_sftdata_att_train_1800,meta_Books_feature_sftdata_att_train_1800,meta_Books_main_category_sftdata_att_train_1800,meta_Books_price_sftdata_att_train_180,meta_Books_Store_sftdata_att_train_1800,meta_Books_title_sftdata_att_train_1800,meta_CDs_and_Vinyl_description_sftdata_att_train_1800,meta_CDs_and_Vinyl_details_sftdata_att_train_1800,meta_CDs_and_Vinyl_feature_sftdata_att_train_1800,meta_CDs_and_Vinyl_main_category_sftdata_att_train_1800,meta_CDs_and_Vinyl_price_sftdata_att_train_1800,meta_CDs_and_Vinyl_Store_sftdata_att_train_1800,meta_CDs_and_Vinyl_title_sftdata_att_train_180,meta_Cell_Phones_and_Accessories_description_sftdata_att_train_1800,meta_Cell_Phones_and_Accessories_details_sftdata_att_train_1800,meta_Cell_Phones_and_Accessories_feature_sftdata_att_train_1800,meta_Cell_Phones_and_Accessories_main_category_sftdata_att_train_1800,meta_Cell_Phones_and_Accessories_price_sftdata_att_train_0,meta_Cell_Phones_and_Accessories_Store_sftdata_att_train_1800,meta_Cell_Phones_and_Accessories_title_sftdata_att_train_180,meta_Clothing_Shoes_and_Jewelry_description_sftdata_att_train_180,meta_Clothing_Shoes_and_Jewelry_details_sftdata_att_train_1800,meta_Clothing_Shoes_and_Jewelry_feature_sftdata_att_train_180,meta_Clothing_Shoes_and_Jewelry_main_category_sftdata_att_train_180,meta_Clothing_Shoes_and_Jewelry_price_sftdata_att_train_30,meta_Clothing_Shoes_and_Jewelry_Store_sftdata_att_train_180,meta_Clothing_Shoes_and_Jewelry_title_sftdata_att_train_180,meta_Digital_Music_description_sftdata_att_train_1800,meta_Digital_Music_details_sftdata_att_train_1800,meta_Digital_Music_feature_sftdata_att_train_1800,meta_Digital_Music_main_category_sftdata_att_train_1800,meta_Digital_Music_price_sftdata_att_train_1800,meta_Digital_Music_Store_sftdata_att_train_1800,meta_Digital_Music_title_sftdata_att_train_1800,meta_Electronics_description_sftdata_att_train_1800,meta_Electronics_details_sftdata_att_train_1800,meta_Electronics_feature_sftdata_att_train_1800,meta_Electronics_main_category_sftdata_att_train_1800,meta_Electronics_price_sftdata_att_train_180,meta_Electronics_Store_sftdata_att_train_1800,meta_Electronics_title_sftdata_att_train_180,meta_Gift_Cards_description_sftdata_att_train_180,meta_Gift_Cards_details_sftdata_att_train_1800,meta_Gift_Cards_feature_sftdata_att_train_180,meta_Gift_Cards_main_category_sftdata_att_train_180,meta_Gift_Cards_price_sftdata_att_train_180,meta_Gift_Cards_Store_sftdata_att_train_180,meta_Gift_Cards_title_sftdata_att_train_180,meta_Grocery_and_Gourmet_Food_description_sftdata_att_train_180,meta_Grocery_and_Gourmet_Food_details_sftdata_att_train_1800,meta_Grocery_and_Gourmet_Food_feature_sftdata_att_train_180,meta_Grocery_and_Gourmet_Food_main_category_sftdata_att_train_180,meta_Grocery_and_Gourmet_Food_price_sftdata_att_filte_train_80,meta_Grocery_and_Gourmet_Food_price_sftdata_att_train_80,meta_Grocery_and_Gourmet_Food_Store_sftdata_att_train_180,meta_Grocery_and_Gourmet_Food_title_sftdata_att_train_180,meta_Handmade_Products_description_sftdata_att_train_1800,meta_Handmade_Products_details_sftdata_att_train_1800,meta_Handmade_Products_feature_sftdata_att_train_1800,meta_Handmade_Products_main_category_sftdata_att_train_1800,meta_Handmade_Products_price_sftdata_att_train_1800,meta_Handmade_Products_Store_sftdata_att_train_1800,meta_Handmade_Products_title_sftdata_att_train_1800,meta_Health_and_Household_description_sftdata_att_train_180,meta_Health_and_Household_details_sftdata_att_train_1800,meta_Health_and_Household_feature_sftdata_att_train_180,meta_Health_and_Household_main_category_sftdata_att_train_180,meta_Health_and_Household_price_sftdata_att_train_29,meta_Health_and_Household_Store_sftdata_att_train_180,meta_Health_and_Household_title_sftdata_att_train_1800,meta_Health_and_Personal_Care_description_sftdata_att_train_180,meta_Health_and_Personal_Care_details_sftdata_att_train_1800,meta_Health_and_Personal_Care_feature_sftdata_att_train_180,meta_Health_and_Personal_Care_main_category_sftdata_att_train_180,meta_Health_and_Personal_Care_price_sftdata_att_train_30,meta_Health_and_Personal_Care_Store_sftdata_att_train_180,meta_Health_and_Personal_Care_title_sftdata_att_train_1800,meta_Home_and_Kitchen_description_sftdata_att_train_180,meta_Home_and_Kitchen_details_sftdata_att_train_1800,meta_Home_and_Kitchen_feature_sftdata_att_train_180,meta_Home_and_Kitchen_main_category_sftdata_att_train_180,meta_Home_and_Kitchen_price_sftdata_att_train_20,meta_Home_and_Kitchen_Store_sftdata_att_train_180,meta_Home_and_Kitchen_title_sftdata_att_train_180,meta_Industrial_and_Scientific_description_sftdata_att_train_180,meta_Industrial_and_Scientific_details_sftdata_att_train_1800,meta_Industrial_and_Scientific_feature_sftdata_att_train_180,meta_Industrial_and_Scientific_main_category_sftdata_att_train_180,meta_Industrial_and_Scientific_price_sftdata_att_train_30,meta_Industrial_and_Scientific_Store_sftdata_att_train_180,meta_Industrial_and_Scientific_title_sftdata_att_train_180,meta_Kindle_Store_description_sftdata_att_train_180,meta_Kindle_Store_details_sftdata_att_train_1800,meta_Kindle_Store_feature_sftdata_att_train_180,meta_Kindle_Store_main_category_sftdata_att_train_180,meta_Kindle_Store_price_sftdata_att_train_20,meta_Kindle_Store_Store_sftdata_att_train_180,meta_Kindle_Store_title_sftdata_att_train_1800,meta_Magazine_Subscriptions_description_sftdata_att_train_180,meta_Magazine_Subscriptions_details_sftdata_att_train_1800,meta_Magazine_Subscriptions_feature_sftdata_att_train_180,meta_Magazine_Subscriptions_main_category_sftdata_att_train_180,meta_Magazine_Subscriptions_price_sftdata_att_train_80,meta_Magazine_Subscriptions_Store_sftdata_att_train_180,meta_Magazine_Subscriptions_title_sftdata_att_train_180,meta_Movies_and_TV_description_sftdata_att_train_180,meta_Movies_and_TV_details_sftdata_att_train_1800,meta_Movies_and_TV_feature_sftdata_att_train_180,meta_Movies_and_TV_main_category_sftdata_att_train_180,meta_Movies_and_TV_price_sftdata_att_train_80,meta_Movies_and_TV_Store_sftdata_att_train_180,meta_Movies_and_TV_title_sftdata_att_train_1800,meta_Musical_Instruments_description_sftdata_att_train_1800,meta_Musical_Instruments_details_sftdata_att_train_1800,meta_Musical_Instruments_feature_sftdata_att_train_1800,meta_Musical_Instruments_main_category_sftdata_att_train_1800,meta_Musical_Instruments_price_sftdata_att_train_180,meta_Musical_Instruments_Store_sftdata_att_train_1800,meta_Musical_Instruments_title_sftdata_att_train_1800,meta_Office_Products_description_sftdata_att_train_180,meta_Office_Products_details_sftdata_att_train_1800,meta_Office_Products_feature_sftdata_att_train_180,meta_Office_Products_main_category_sftdata_att_train_180,meta_Office_Products_price_sftdata_att_train_180,meta_Office_Products_Store_sftdata_att_train_180,meta_Office_Products_title_sftdata_att_train_180,meta_Patio_Lawn_and_Garden_description_sftdata_att_train_180,meta_Patio_Lawn_and_Garden_details_sftdata_att_train_1800,meta_Patio_Lawn_and_Garden_feature_sftdata_att_train_180,meta_Patio_Lawn_and_Garden_main_category_sftdata_att_train_180,meta_Patio_Lawn_and_Garden_price_sftdata_att_train_80,meta_Patio_Lawn_and_Garden_Store_sftdata_att_train_180,meta_Patio_Lawn_and_Garden_title_sftdata_att_train_180,meta_Pet_Supplies_description_sftdata_att_train_1800,meta_Pet_Supplies_details_sftdata_att_train_1800,meta_Pet_Supplies_feature_sftdata_att_train_1800,meta_Pet_Supplies_main_category_sftdata_att_train_1800,meta_Pet_Supplies_price_sftdata_att_train_1800,meta_Pet_Supplies_Store_sftdata_att_train_1800,meta_Pet_Supplies_title_sftdata_att_train_180,meta_Software_description_sftdata_att_train_1800,meta_Software_details_sftdata_att_train_1800,meta_Software_feature_sftdata_att_train_1800,meta_Software_main_category_sftdata_att_train_1800,meta_Software_price_sftdata_att_train_180,meta_Software_Store_sftdata_att_train_1800,meta_Software_title_sftdata_att_train_1800,meta_Sports_and_Outdoors_description_sftdata_att_train_180,meta_Sports_and_Outdoors_details_sftdata_att_train_1800,meta_Sports_and_Outdoors_feature_sftdata_att_train_180,meta_Sports_and_Outdoors_main_category_sftdata_att_train_180,meta_Sports_and_Outdoors_price_sftdata_att_train_30,meta_Sports_and_Outdoors_Store_sftdata_att_train_180,meta_Sports_and_Outdoors_title_sftdata_att_train_180,meta_Subscription_Boxes_description_sftdata_att_train_1800,meta_Subscription_Boxes_details_sftdata_att_train_1800,meta_Subscription_Boxes_feature_sftdata_att_train_1800,meta_Subscription_Boxes_main_category_sftdata_att_train_1800,meta_Subscription_Boxes_price_sftdata_att_train_1800,meta_Subscription_Boxes_Store_sftdata_att_train_1800,meta_Subscription_Boxes_title_sftdata_att_train_180,meta_Tools_and_Home_Improvement_description_sftdata_att_train_1800,meta_Tools_and_Home_Improvement_details_sftdata_att_train_1800,meta_Tools_and_Home_Improvement_feature_sftdata_att_train_1800,meta_Tools_and_Home_Improvement_main_category_sftdata_att_train_1800,meta_Tools_and_Home_Improvement_price_sftdata_att_train_1800,meta_Tools_and_Home_Improvement_Store_sftdata_att_train_1800,meta_Tools_and_Home_Improvement_title_sftdata_att_train_180,meta_Toys_and_Games_description_sftdata_att_train_1800,meta_Toys_and_Games_details_sftdata_att_train_1800,meta_Toys_and_Games_feature_sftdata_att_train_1800,meta_Toys_and_Games_main_category_sftdata_att_train_1800,meta_Toys_and_Games_price_sftdata_att_train_1800,meta_Toys_and_Games_Store_sftdata_att_train_1800,meta_Toys_and_Games_title_sftdata_att_train_180,meta_Video_Games_description_sftdata_att_train_180,meta_Video_Games_details_sftdata_att_train_1800,meta_Video_Games_feature_sftdata_att_train_180,meta_Video_Games_main_category_sftdata_att_train_180,meta_Video_Games_price_sftdata_att_train_30,meta_Video_Games_Store_sftdata_att_train_180,meta_Video_Games_title_sftdata_att_train_1800}.json" \
    --image_folder ./msdata/images/images/ \
    --mm_vision_tower_lr=2e-6 \
    --vision_tower $VISION_MODEL_VERSION \
    --mm_projector_type mlp2x_gelu \
    --mm_vision_select_layer -2 \
    --mm_use_im_start_end False \
    --mm_use_im_patch_token False \
    --group_by_modality_length True \
    --image_aspect_ratio anyres_max_9 \
    --image_grid_pinpoints  "(1x1),...,(6x6)" \
    --mm_patch_merge_type spatial_unpad \
    --bf16 True \
    --run_name $RUN_NAME \
    --output_dir $OUTPUT_DIR \
    --num_train_epochs 1 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 1 \
    --gradient_accumulation_steps 2 \
    --evaluation_strategy "no" \
    --save_strategy "steps" \
    --save_steps 300 \
    --save_total_limit 1 \
    --learning_rate 1e-5 \
    --weight_decay 0. \
    --warmup_ratio 0.03 \
    --lr_scheduler_type "cosine" \
    --logging_steps 1 \
    --tf32 True \
    --model_max_length 32768 \
    --gradient_checkpointing True \
    --dataloader_num_workers 4 \
    --lazy_preprocess True \
    --report_to wandb \
    --torch_compile True \
    --torch_compile_backend "inductor" \
    --dataloader_drop_last True \
    --frames_upbound 32 \
    --use_ewc false \
    --ewc_lambda 0.1
exit 0;

    # --mm_tunable_parts="mm_vision_tower,mm_mlp_adapter,mm_language_model" \


    # --data_path "/home/aiscuser/dataset/Amazon/{meta_All_Beauty_exist_gene_ITdata,meta_Appliances_exist_gene_ITdata,meta_Arts_Crafts_and_Sewing_exist_gene_ITdata,meta_Beauty_and_Personal_Care_exist_gene_ITdata,meta_Cell_Phones_and_Accessories_exist_gene_ITdata,meta_Digital_Music_exist_gene_ITdata,meta_Electronics_exist_gene_ITdata,meta_Gift_Cards_exist_gene_ITdata,meta_Grocery_and_Gourmet_Food_exist_gene_ITdata,meta_Health_and_Household_exist_gene_ITdata,meta_Industrial_and_Scientific_exist_gene_ITdata,meta_Magazine_Subscriptions_exist_gene_ITdata,meta_Movies_and_TV_exist_gene_ITdata,meta_Patio_Lawn_and_Garden_exist_gene_ITdata,meta_Sports_and_Outdoors_exist_gene_ITdata,meta_Subscription_Boxes_exist_gene_ITdata,meta_Toys_and_Games_exist_gene_ITdata}.json" \
    # --data_path "/home/aiscuser/dataset/Amazon/{meta_Gift_Cards_exist_gene_ITdata}.json" \


# You can delete the sdpa attn_implementation if you want to use flash attn
#     --video_folder /mnt/bn/vl-research/data/llava_video \

    # --data_path ./download_data/mydatasets/llava_onevision/llava_onevision_FigureQA_MathV360K.json \
    # --image_folder ./download_data/mydatasets/llava_onevision/images/FigureQA_MathV360K \
