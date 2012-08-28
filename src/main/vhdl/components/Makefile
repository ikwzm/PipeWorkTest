ENTITY_FILES = chopper.vhd                             \
               reducer.vhd                             \
               queue_arbiter.vhd                       \
               delay_register.vhd                      \
               delay_adjuster.vhd                      \
               syncronizer.vhd                         \
               sdpram.vhd
               ${ENDLIST}

components.vhd : ${ENTITY_FILES}
	../../../../Dummy_Plug/tools/MakeComponentPackage.rb --verbose \
            --brief   'PIPEWORK COMPONENT LIBRARY DESCRIPTION' \
            --version 1.0.2 \
            --author  'Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>' \
            --library PIPEWORK \
            --package COMPONENTS \
            --output  components.vhd \
            ${ENTITY_FILES}

clean:
	-rm components.vhd
