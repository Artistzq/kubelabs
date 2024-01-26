# 获取所有名称以 'cni-test-cluster' 开头的容器
container_names=$(docker ps --format "{{.Names}}" | grep '^cni-test-cluster')

# 定义本地压缩文件路径和目标解压目录（请替换为实际值）
local_archive="cni-plugins-linux-amd64-v1.4.0.tgz"
target_directory="/opt/cni/bin"

# 遍历每个匹配到的容器
for name in $container_names; do
    # 将本地压缩文件复制到容器内
    docker cp "$local_archive" "$name:$target_directory"
    # 在容器内部执行解压命令
    docker exec -it "$name" bash -c "cd '$target_directory' && tar -zxvf '$local_archive'"
    # 展示文件夹下内容
    docker exec -it "$name" bash -c "cd '$target_directory' && ls"
done
echo "Finished deploying files to containers."
