#!/bin/bash
# Usage: ./scripts/add_praticien.sh

set -e

echo ""
echo "── Ajouter un praticien ──────────────────────"
read -p "Slug (ex: diakite)          : " SLUG
read -p "Nom complet                 : " NAME
read -p "Rôle                        : " ROLE
read -p "Pays (emoji, ex: 🇫🇷)       : " COUNTRY
read -p "Ville                       : " CITY
read -p "Catégorie (data/devops/cloud/ia/cybersecurite/mlops/dev) : " CATEGORY
read -p "Stack (séparé par virgules) : " STACK_RAW
read -p "Bio courte                  : " BIO
read -p "LinkedIn URL                : " LINKEDIN
read -p "GitHub URL                  : " GITHUB
read -p "Disponible ? (true/false)   : " OPEN

# Formate la stack en tableau JS
STACK_JS=$(echo "$STACK_RAW" | sed 's/,\s*/", "/g')
STACK_JS="[\"$STACK_JS\"]"

echo ""
echo "── Création du profil QMD ────────────────────"
cat > "praticiens/$SLUG.qmd" << EOF
---
title: "$NAME"
role: "$ROLE"
country: "$COUNTRY"
city: "$CITY"
stack: [$STACK_RAW]
linkedin: "$LINKEDIN"
github: "$GITHUB"
bio: "$BIO"
open_to_work: $OPEN
listing: false
---
\`\`\`{=html}
<div style="padding:3rem 6vw; max-width:900px; margin:0 auto;">

  <div style="margin-bottom:2rem;">
    <a href="../praticiens/index.html" style="font-family:'Space Mono',monospace; font-size:0.72rem; color:#6b7280; text-decoration:none;">← Praticiens</a>
  </div>

  <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:1rem; margin-bottom:2rem;">
    <div>
      <h1 style="font-family:'Syne',sans-serif; font-size:clamp(1.6rem,4vw,2.2rem); font-weight:800; color:#e8e4d9; margin:0 0 0.4rem 0;">$NAME</h1>
      <p style="font-family:'Space Mono',monospace; font-size:0.8rem; color:#f0a500; margin:0;">$ROLE</p>
      <p style="font-family:'Space Mono',monospace; font-size:0.75rem; color:#6b7280; margin:0.3rem 0 0 0;">$COUNTRY $CITY</p>
    </div>
    <div style="display:flex; gap:0.75rem; flex-wrap:wrap; align-items:center;">
EOF

  if [ -n "$GITHUB" ]; then
    echo "      <a href=\"$GITHUB\" target=\"_blank\" style=\"font-family:'Space Mono',monospace; font-size:0.72rem; color:#6b7280; border:1px solid #1e2128; padding:4px 14px; border-radius:2px; text-decoration:none;\">GitHub</a>" >> "praticiens/$SLUG.qmd"
  fi
  if [ -n "$LINKEDIN" ]; then
    echo "      <a href=\"$LINKEDIN\" target=\"_blank\" style=\"font-family:'Space Mono',monospace; font-size:0.72rem; color:#6b7280; border:1px solid #1e2128; padding:4px 14px; border-radius:2px; text-decoration:none;\">LinkedIn</a>" >> "praticiens/$SLUG.qmd"
  fi

cat >> "praticiens/$SLUG.qmd" << EOF
    </div>
  </div>

  <p style="font-size:0.95rem; color:#9ca3af; line-height:1.8; max-width:600px; margin-bottom:2rem;">$BIO</p>

  <div style="display:flex; flex-wrap:wrap; gap:0.4rem; margin-bottom:3rem;">
$(echo "$STACK_RAW" | tr ',' '\n' | sed 's/^ *//;s/ *$//' | while read s; do
  echo "    <span style=\"font-family:'Space Mono',monospace; font-size:0.72rem; color:#6b7280; border:1px solid #1e2128; padding:3px 10px; border-radius:2px;\">$s</span>"
done)
  </div>

</div>
\`\`\`
EOF

echo "✓ praticiens/$SLUG.qmd créé"

echo ""
echo "── Rebuild ───────────────────────────────────"
quarto render

echo ""
echo "── Git commit ────────────────────────────────"
git add praticiens/$SLUG.qmd praticiens/index.qmd docs/
git commit -m "add praticien: $NAME"

echo ""
echo "✓ Prêt ! Lance : git push"
echo ""
