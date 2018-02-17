(ns soup.core
  (:import [com.acme.soup Soup]))

(-> (Soup.)  ;; Create a instance of soup
    (.make)) ;; Call native functions on it
