#!/bin/bash

function worker_image_for {
  LANGUAGE=$1

  ruby <<RUBY
    \$LOAD_PATH << '.'
    require 'lib/${LANGUAGE}_runner'

    puts Mumukit.config.docker_image
RUBY
}

TAG=$(worker_image_for cpp)

echo "Pulling $TAG..."
docker pull $TAG
