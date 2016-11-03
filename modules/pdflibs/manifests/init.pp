class pdflibs {
    package { [
            "libcairo2-dev",
            "pango1.0-tests",
            "libgdk-pixbuf2.0-0"
        ]:
        ensure => latest
    }
}