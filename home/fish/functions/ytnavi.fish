function ytnavi -d "Fetch YouTube music with full metadata for Navidrome library"
    set -l meta_args
    argparse 'album=' 'artist=' -- $argv || return

    if test (count $argv) -eq 0
        echo "error: at least one url required" >&2
        return 1
    end
    if set -q _flag_album
        set -a meta_args "-metadata album='$_flag_album[1]'"
    end
    if set -q _flag_artist
        set -a meta_args "-metadata artist='$_flag_artist[1]'"
    end

    command yt-dlp \
        --extract-audio \
        --add-metadata \
        --embed-thumbnail \
        --parse-metadata 'playlist_index:%(track_number)s' \
        --convert-thumbnails jpg \
        --postprocessor-args "ffmpeg: -c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
        --postprocessor-args "Metadata:$meta_args" \
        --retries infinite \
        --extractor-retries infinite \
        --force-overwrite \
        --output "%(playlist_index|)s%(playlist_index&. |)s%(title)s [%(id)s].%(ext)s" \
        $argv
end
