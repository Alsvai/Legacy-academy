# The Legacy Academy — version avec espace staff sécurisé

## Ce qui est ajouté
- L'espace staff n'apparaît plus dans le menu public.
- Il s'ouvre uniquement avec `?staff=1`.
- Connexion e-mail / mot de passe via Supabase Auth.
- Seuls les comptes dont le `app_metadata.role` vaut `staff` peuvent accéder aux actions staff.
- Dans le tableau de bord, le staff peut modifier le nombre de descendants de chaque parent (0 à 3), puis enregistrer.
- Les nombres, disponibilités et options de tirage sont stockés dans Supabase et partagés avec les visiteurs.

## Installation Supabase
1. Créez un projet sur https://supabase.com/.
2. Dans **SQL Editor**, exécutez le contenu de `supabase/schema.sql`.
3. Dans **Project Settings > API**, copiez l'URL du projet et la clé `anon` / publishable.
4. Dans `index.html`, remplacez :
   - `https://VOTRE-PROJET.supabase.co` par l'URL de votre projet ;
   - `VOTRE_CLE_ANON` par la clé anon / publishable.
5. Dans **Authentication > Users**, créez un utilisateur avec e-mail et mot de passe pour chaque membre staff.
6. Pour chaque utilisateur staff, attribuez `app_metadata` avec le rôle `staff`. Dans Supabase, cela se fait via une action administrative (Dashboard / serveur de confiance), jamais depuis le navigateur. Exemple de valeur :
   ```json
   {"role":"staff"}
   ```
   Ne mettez jamais une clé `service_role` dans `index.html`.

## Premier chargement du répertoire
- Après configuration, ouvrez le site normalement. Le site public lit les lignées de la table `parents`.
- Ouvrez ensuite `https://VOTRE-PSEUDO.github.io/VOTRE-DEPOT/?staff=1`, connectez-vous avec un compte staff.
- Si la table est vide, la connexion staff importe le répertoire initial du site.
- Les lignes déjà présentes ne sont pas réinitialisées : les nombres saisis par le staff sont conservés.

## Utilisation staff
1. Ouvrez l'URL avec `?staff=1`.
2. Connectez-vous.
3. Dans **Gestion des parents**, modifiez le champ **Descendants** entre 0 et 3.
4. Cliquez sur **Enregistrer**. La modification est stockée dans Supabase.
5. Le bouton **Se déconnecter** ferme la session.

## Important
- Le système protège les modifications des lignées côté base de données avec RLS. Masquer l'URL n'est pas la protection : c'est l'authentification Supabase et les règles SQL qui protègent l'accès.
- Les demandes de réservation et les fiches de personnages restent locales à cette version ; elles ne sont pas encore synchronisées entre les visiteurs.
- N'ajoutez jamais la clé `service_role` dans le code du site.
