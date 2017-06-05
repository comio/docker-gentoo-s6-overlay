#!/bin/sh

# Load default environment

function write_build_env()
{
	echo "IMAGE_RELEASE=${IMAGE_RELEASE}" > ./.build.env
	echo "BUILD_DATE=\"${BUILD_DATE}\"" >> ./.build.env
}

function load_build_env()
{
	build=1
	freeze_version=0
	tag=1
	push=1
	. ./build.env
	[ -f ./.build.env ] && . ./.build.env

	[ -z "${IMAGE_RELEASE}" ] && IMAGE_RELEASE=0
	[ -z "${BUILD_DATE}" ] && BUILD_DATE="`date --utc -R`"
}

function show_build_env()
{
    echo "IMAGE_NAME: ${IMAGE_NAME}"
    echo "IMAGE_RELEASE: ${IMAGE_RELEASE}"
    echo "GENTOO_RELEASE: ${GENTOO_RELEASE}"
    echo "BUILD_DATE: ${BUILD_DATE}"
}

load_build_env

while [ -n "$1" ]; do
    case $1 in
	--build)
		build=1
		;;
	--no-build)
		build=0
		;;
	--freeze-version)
		freeze_version=1
		;;
	--no-freeze-version)
		freeze_version=0
		;;
	--tag)
		tag=1
		;;
	--no-tag)
		tag=0
		;;
	--push)
		push=1
		;;
	--no-push)
		push=0
		;;
    esac
    shift
done


if [ $freeze_version -eq 0 ]; then
	IMAGE_RELEASE=$((${IMAGE_RELEASE}+1))
	BUILD_DATE="`date --utc -R`"
fi

echo "Build image ${IMAGE_NAME} #${IMAGE_RELEASE} based on ${GENTOO_RELEASE}"

if [ $tag -ne 0 ]; then
	TAG_STRING="-t ${IMAGE_NAME}:latest -t ${IMAGE_NAME}:${GENTOO_RELEASE} -t ${IMAGE_NAME}:${IMAGE_RELEASE}"
else
        TAG_STRING=""
fi


if [ $build -ne 0 ]; then
	docker build \
		--build-arg GENTOO_RELEASE="${GENTOO_RELEASE}" \
		--build-arg IMAGE_RELEASE="${IMAGE_RELEASE}" \
		--build-arg BUILD_DATE="${BUILD_DATE}" \
		$TAG_STRING \
		.
fi

if [ $push -ne 0 ]; then
	docker push ${IMAGE_NAME}:latest &&
	docker push ${IMAGE_NAME}:${GENTOO_RELEASE} &&
	docker push ${IMAGE_NAME}:${IMAGE_RELEASE}
fi

write_build_env

exit 0
