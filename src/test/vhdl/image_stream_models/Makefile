ENTITY_FILES = image_stream_master_player.vhd \
               image_stream_slave_player.vhd  \
               ${ENDLIST}

image_stream_models.vhd : ${ENTITY_FILES}
	../../../../PipeWork/tools/MakeComponentPackage.rb --verbose \
            --brief   'Image Stream Model Component Package' \
            --version 1.8.0 \
            --author  'Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>' \
            --library PIPEWORK \
            --package IMAGE_STREAM_MODELS \
            --output  image_stream_models.vhd \
            ${ENTITY_FILES}

clean:
	-rm image_stream_models.vhd
