RestFull-One
============

RestFull Plugin for Framework One / fw1


INSTALL
-------

1 - Add Files to your Framework/One project. You need DI/1 too.

2 - Add your service based on helloWorld Sample

3 - Play with it !


How To 
------

Create a function on Rest Folder with 'uri' and 'method' parameters :

@uri /helloWorld/sayHello/:name
@method GET

uri: will contain your uri after the "rest" base path /<component>/<function>/[:parameter]

method: will be the HTTP Method used (GET|POST|DELETE|PUT) 


LICENCE
-------

Copyright (c) 2013, Jerome Lepage http://www.jlepage.info

This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License <br/>
http://creativecommons.org/licenses/by-sa/3.0/

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.