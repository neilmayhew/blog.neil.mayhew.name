--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

import Hakyll

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
  match "images/*" $ do
    route idRoute
    compile copyFileCompiler

  match "css/*" $ do
    route idRoute
    compile compressCssCompiler

  match "js/*" $ do
    route idRoute
    compile copyFileCompiler

  match ("posts/*" .||. "drafts/*") $ do
    route $ setExtension "html"
    compile $ do
      let pageCtx =
            mconcat
              [ field "recent_posts" (const recentPostList)
              , field "all_pages" (const allPagesList)
              , postCtx
              ]

      pandocCompiler
        >>= loadAndApplyTemplate "templates/post.html" postCtx
        >>= loadAndApplyTemplate "templates/default.html" pageCtx
        >>= relativizeUrls

  match "pages/*" $ do
    route $ setExtension "html"
    compile $ do
      let pagesCtx =
            mconcat
              [ field "recent_posts" (const recentPostList)
              , field "all_pages" (const allPagesList)
              , constField "title" blogTitle
              , constField "site_desc" siteDesc
              , defaultContext
              ]

      pandocCompiler
        >>= loadAndApplyTemplate "templates/page.html" defaultContext
        >>= loadAndApplyTemplate "templates/default.html" pagesCtx
        >>= relativizeUrls

  create ["archive.html"] $ do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll "posts/*"
      let archiveCtx =
            mconcat
              [ listField "posts" postCtx (return posts)
              , field "recent_posts" (const recentPostList)
              , field "all_pages" (const allPagesList)
              , constField "title" "Archives"
              , constField "site_desc" siteDesc
              , defaultContext
              ]

      makeItem ""
        >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
        >>= loadAndApplyTemplate "templates/default.html" archiveCtx
        >>= relativizeUrls

  match "index.html" $ do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll "posts/*"
      let indexCtx =
            mconcat
              [ listField "posts" postCtx (return posts)
              , field "recent_posts" (const recentPostList)
              , field "all_pages" (const allPagesList)
              , constField "title" blogTitle
              , constField "site_desc" siteDesc
              , defaultContext
              ]

      getResourceBody
        >>= applyAsTemplate indexCtx
        >>= loadAndApplyTemplate "templates/default.html" indexCtx
        >>= relativizeUrls

  match "templates/*" $ compile templateBodyCompiler

--------------------------------------------------------------------------------
-- Metadata
postCtx :: Context String
postCtx =
  mconcat
    [ dateField "date" "%B %e, %Y"
    , constField "site_desc" siteDesc
    , defaultContext
    ]

blogTitle :: String
blogTitle = "Neil’s Blog"

siteDesc :: String
siteDesc = "An occasional glimpse into my world"

--------------------------------------------------------------------------------
-- Pages
allPages :: Compiler [Item String]
allPages = do
  identifiers <- getMatches "pages/*"
  return [Item identifier "" | identifier <- identifiers]

allPagesList :: Compiler String
allPagesList = do
  pages <- allPages
  itemTpl <- loadBody "templates/listitem.html"
  applyTemplateList itemTpl defaultContext pages

--------------------------------------------------------------------------------
-- Recent Posts
recentPosts :: Compiler [Item String]
recentPosts = do
  identifiers <- getMatches "posts/*"
  return [Item identifier "" | identifier <- identifiers]

recentPostList :: Compiler String
recentPostList = do
  posts <- fmap (take 10) . recentFirst =<< recentPosts
  itemTpl <- loadBody "templates/listitem.html"
  applyTemplateList itemTpl defaultContext posts
