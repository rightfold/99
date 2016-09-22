package index

import "net/http"

type API struct {
	index *Index
}

func NewAPI(index *Index) *API {
	return &API{index: index}
}

func (a *API) ServeHTTP(res http.ResponseWriter, req *http.Request) {

}
