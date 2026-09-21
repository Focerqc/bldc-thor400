# shared.mk
#
# environment variables common to all operating systems supported by the make system
# C.f. https://gist.github.com/sighingnow/deee806603ec9274fd47

OSFLAG :=

ifeq ($(OS),Windows_NT)
  # Check if we're actually running inside an MSYS2/Cygwin shell
  # If uname is available, defer to it (treat as Linux build environment)
  UNAME_CHECK := $(shell uname -s 2>/dev/null)
  ifneq ($(UNAME_CHECK),)
    # Running inside MSYS2/Cygwin subshell — treat as Linux
    OSFLAG += -D LINUX
    OSFAMILY := linux
    LINUX := 1
  else
    OSFLAG += -D WIN32
    OSFAMILY := windows
    WINDOWS := 1
    ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
      OSFLAG += -D AMD64
    endif
    ifeq ($(PROCESSOR_ARCHITECTURE),x86)
      OSFLAG += -D IA32
    endif
  endif
else
  UNAME_S := $(shell uname -s)
  ifeq ($(UNAME_S),Linux)
    OSFLAG += -D LINUX
    OSFAMILY := linux
    LINUX := 1
  endif

  ifeq ($(UNAME_S),Darwin)
    OSFLAG += -D OSX
    OSFAMILY := macos
    MACOS := 1
  endif

  UNAME_P := $(shell uname -p)
  ifeq ($(UNAME_P),x86_64)
    OSFLAG += -D AMD64
  endif

  ifneq ($(filter %86,$(UNAME_P)),)
  OSFLAG += -D IA32
  endif

  ifneq ($(filter arm%,$(UNAME_P)),)
    OSFLAG += -D ARM
  endif
endif

# report an error if we couldn't work out what OS this is running on
ifndef OSFAMILY
  $(info uname reports $(UNAME))
  $(info uname -m reports $(ARCH))
  $(error failed to detect operating system)
endif
