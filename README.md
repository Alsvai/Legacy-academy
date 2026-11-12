# Legacy Academy

Site web statique de l'académie RP, prêt pour GitHub Pages.

## Publier le site avec GitHub Pages

1. Crée un nouveau dépôt sur GitHub (par exemple `legacy-academy`).
2. Envoie `index.html`, `.nojekyll` et `README.md` à la racine du dépôt.
3. Ouvre **Settings > Pages** dans le dépôt.
4. Dans **Build and deployment**, sélectionne **Deploy from a branch**.
5. Choisis la branche `main` et le dossier `/ (root)`, puis valide avec **Save**.
6. Attends la publication : GitHub affichera l'adresse de ton site dans la section Pages.

## Important

Cette version fonctionne comme une démonstration statique. Les données enregistrées dans le navigateur (localStorage), comme les fiches et les réservations, ne sont pas partagées entre les visiteurs ou les appareils. L'espace staff n'est pas sécurisé pour une utilisation réelle. Pour un serveur RP avec plusieurs joueurs, il faudra connecter une base de données et une authentification (par exemple Supabase) et sécuriser les droits côté serveur.
