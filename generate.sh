#!/usr/bin/env bash
#
# Generates "README.md" top 50 movies
#
# Variables
DATE="$(date +%m/%d/%y)"

# Colors
NC="\033[0m"
RED="\033[0;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"

# Main Script
git remote remove origin
git remote add origin https://"${GH_REF}"
git fetch --all
echo ""
# echo -e "# Top IMDB 50 Movies Data Scrapper\n" > README.md
# echo -e "Top 50 Movies as of: **$(date +%m/%d/%Y)**\n" >> README.md
./IMDB.py 1> /dev/null
ERROR_CODE="$?"
if [[ "${ERROR_CODE}" != "0" ]]; then
    echo -e "${RED}Python program failed${NC}"
    echo -e "${RED}Exiting...${NC}"
    exit 1
fi
echo -e "${GREEN}'README.md' file generated${NC}"
echo ""
echo -e "${GREEN}'Data/data.json' file generated${NC}"
echo ""
cd Data || exit 1
csvtojson data.csv > data.json
echo "Prettify..."
prettier --write .
echo ""
cd "${TRAVIS_BUILD_DIR}" || exit 1
if [[ -z $(git status --porcelain) ]]; then
    echo -e "${GREEN}Nothing to Update${NC}"
else
    echo -e "${YELLOW}File(s) changed -${NC}"
    git diff --name-only
    git config user.email "49350241+crazyuploader@users.noreply.github.com"
    git config user.name "crazyuploader"
    git add .
    git commit -m "Travis CI ${DATE} [skip travis]"
    git push https://crazyuploader:"${GITHUB_TOKEN}"@"${GH_REF}" HEAD:"${TRAVIS_BRANCH}"
    echo ""
    echo -e "${YELLOW}Changes pushed to${NC} ${GREEN}'https://github.com/crazyuploader/IMDB_TOP_50'${NC}"
fi
echo ""
echo -e "${YELLOW}------O-U-T-P-U-T------"
echo ""
./IMDB.py 
echo ""