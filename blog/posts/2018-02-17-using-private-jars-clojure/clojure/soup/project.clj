(defproject soup "0.1.0-SNAPSHOT"
  :description "Example for loading local jars in clojure"
  :url "https://ahmadnazir.github.io"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [com.acme.soup/soup "1.0-SNAPSHOT"]]
  :repositories {"project" "file:localrepo"}
  )
