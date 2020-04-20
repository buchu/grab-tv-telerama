#!/bin/bash

OUTPUT="/app"

[ -f /app/.xmltv/tv_grab_fr_telerama.conf ] || echo -e "yes\nall" | tv_grab_fr_telerama --configure
cd ${OUTPUT} && python3 -m http.server

