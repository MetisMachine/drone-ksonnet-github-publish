#!/bin/bash

BRANCH="${DRONE_BUILD_NUMBER}-${PLUGIN_TAG}-${PLUGIN_KS_ENV}"
DIR=$(mktemp -d)

git config --global user.email "drone@drone.io"
git config --global user.name "drone"

echo "Cloning ksonnet repo.."
git clone "https://${GITHUB_TOKEN}:x-oauth-basic@github.com/${PLUGIN_GITHUB_ORG}/${PLUGIN_GITHUB_REPO}.git" "${DIR}" || exit 1

cd "${DIR}" || exit 1

echo "Create branch for PR..."
git checkout -b "${BRANCH}" || echo "branch exists..."

echo "Updating ${PLUGIN_KS_COMPONENT} image for environment ${PLUGIN_KS_ENV}"
ks param set "${PLUGIN_KS_COMPONENT}" \
  image \
  "${PLUGIN_DOCKER_REPO}:${PLUGIN_TAG}" \
  --env "${PLUGIN_KS_ENV}" || exit 1

git add environments/.

echo "Commit changes..."
git commit -m "Drone auto-publish: ${PLUGIN_KS_COMPONENT} to ${PLUGIN_TAG}" || exit

echo "Pushing branch"
hub push origin "${BRANCH}" || exit 1

echo "Creating Pull Request..."

PR_MSG=$(cat <<EOF
${DRONE_REPO_NAME} ${PLUGIN_TAG} ${PLUGIN_KS_ENV}

[Build #${DRONE_BUILD_NUMBER}](${DRONE_BUILD_LINK})
${PLUGIN_DOCKER_REPO}:${PLUGIN_TAG}
Generated by Drone
EOF
)

hub pull-request -m "${PR_MSG}" || exit 1

echo "DONE!!!"
