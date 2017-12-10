$(document).ready(function() {
    if ($("#camera").length) {
        Webcam.set({
            width: 320,
            height: 240,
            image_format: 'jpeg',
            jpeg_quality: 90
        });

        Webcam.attach('#camera');
    }
});