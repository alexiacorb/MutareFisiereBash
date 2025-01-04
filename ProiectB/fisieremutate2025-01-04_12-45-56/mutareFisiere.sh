#!/bin/bash

# Funcție pentru căutarea tuturor fisierelor pentru a fi mutate 
cautare_fisiere(){
    locatie="$1"
    find "$locatie" -type f -print0
}

# Funcție pentru a muta fișierele găsite local într-o destinație specificată
mutare_fisiere_local(){
    destinatie="$1"
    if [ ! -d "$destinatie" ]; then
        echo "Locația $destinatie nu există pe acest dispozitiv."
        mkdir -p "$destinatie" && echo "Locația $destinatie a fost creată cu succes."
    else
        echo "Locația $destinatie există deja pe acest dispozitiv."
    fi

    cautare_fisiere . | xargs -0 -I {} mv {} "$destinatie" && echo "Fișierele au fost mutate cu succes în $destinatie." || echo "Eroare la mutarea fișierelor local în $destinatie."
}

# Funcție pentru configurarea inițială a repository-ului Git
configurare_git(){
    # Verifică dacă directorul curent este un repository Git valid
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Repository-ul git este deja inițializat."
    else
        git init && echo "Repository-ul git a fost inițializat cu succes." || echo "Eroare la inițializarea repository-ului."
    fi
    git config --local user.email "alexia.corb04@e-uvt.ro"
    git config --local user.name "Corb Alexia"
}

# Funcție pentru mutarea fișierelor și gestionarea Git
mutare_fisiere_git(){
    configurare_git 
    timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
    destinatie="fisieremutate$timestamp"
    mkdir -p "$destinatie"
    cautare_fisiere . | xargs -0 -I {} mv {} "$destinatie" || echo "Eroare la mutarea fișierelor în $destinatie."
    git add . && echo "Fișiere adăugate cu succes în staging area."
    git commit -m "Fișiere mutate $timestamp" && echo "Fișierele au fost commise cu succes."
}

# Apel funcție
mutare_fisiere_git

