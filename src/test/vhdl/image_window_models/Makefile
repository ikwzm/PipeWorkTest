ENTITY_FILES = image_window_master_player.vhd \
               image_window_slave_player.vhd  \
               ${ENDLIST}

image_window_models.vhd : ${ENTITY_FILES}
	../../../../PipeWork/tools/MakeComponentPackage.rb --verbose \
            --brief   'Image Window Model Component Package' \
            --version 1.8.0 \
            --author  'Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>' \
            --library PIPEWORK \
            --package IMAGE_WINDOW_MODELS \
            --output  image_window_models.vhd \
            ${ENTITY_FILES}

clean:
	-rm image_window_models.vhd
