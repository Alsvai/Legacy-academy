# The Legacy Academy

Site statique prévu pour GitHub Pages. Le répertoire public reste consultable sans compte. L'espace staff est accessible uniquement via `?staff=1` et nécessite un compte Supabase authentifié, inscrit dans `staff_members`.

## 1. Créer le projet Supabase

1. Crée un projet sur https://supabase.com/.
2. Dans **SQL Editor**, exécute le contenu de `supabase/schema.sql`.
3. Dans **Project Settings → API**, récupère l'URL du projet et la clé publique **anon** (ou publishable).
4. Dans `index.html`, remplace :
   - `COLLEZ_ICI_URL_SUPABASE`
   - `COLLEZ_ICI_CLE_ANON_SUPABASE`

   La clé anon/publishable est prévue pour le navigateur et les accès sont limités par les règles RLS du SQL. Ne mets jamais une clé `service_role` dans `index.html`.

## 2. Créer les comptes staff

1. Dans Supabase, ouvre **Authentication → Users → Add user**.
2. Crée un compte par membre du staff avec son adresse e-mail et un mot de passe robuste.
3. Copie l'UUID de chaque utilisateur créé.
4. Dans **SQL Editor**, exécute une requête pour chaque membre, en remplaçant l'UUID :

```sql
insert into public.staff_members (user_id)
values ('UUID-DE-L-UTILISATEUR');
```

Seuls les comptes présents dans `staff_members` peuvent ouvrir le tableau de bord et modifier les réglages. Le mot de passe n'est jamais écrit dans le code du site.

## 3. Accéder à l'espace staff

Après publication, le staff ouvre l'adresse du site suivie de `?staff=1`, par exemple :

`https://TON-PSEUDO.github.io/legacy-academy/?staff=1`

La page de connexion n'est pas affichée dans la navigation publique. Le paramètre d'URL n'est pas une protection à lui seul : la véritable protection est assurée par Supabase Auth et les politiques RLS.

## 4. Gérer les descendants

Dans l'espace staff, chaque parent dispose d'un champ **Descendants** réglable de 0 à 3 et d'un bouton **Enregistrer**. Les nombres, l'ouverture aux réservations et l'inclusion au tirage sont stockés dans `parent_settings` et partagés avec les visiteurs du site.

## Limites actuelles

La connexion staff et les réglages des lignées (nombre de descendants, disponibilité, inclusion au tirage) sont reliés à Supabase. Les demandes de réservation et les fiches élèves du prototype initial restent encore enregistrées localement dans le navigateur : elles ne sont pas encore partagées entre tous les membres. Il faudra leur ajouter des tables et des règles RLS dédiées avant de les utiliser en production.

## Publication GitHub Pages

Dépose `index.html`, `README.md`, `.nojekyll` et le dossier `supabase/` à la racine du dépôt. Puis va dans **Settings → Pages → Deploy from a branch → main → /(root) → Save**.
